import { Utility } from '../model/Utility';
import { preferences } from '@kit.ArkData';
import { hilog } from '@kit.PerformanceAnalysisKit';

export class WaterKeeper {
  private currentDate: string;
  private dataPreferences?: preferences.Preferences;
  private storage: LocalStorage;
  private dayTimer?: number;
  private isTransitioning: boolean = false;
  private isDisposed: boolean = false;

  constructor(context: Context, storage: LocalStorage) {
    this.storage = storage;
    this.currentDate = this.prepareDateForUID();
    this.storage.setOrCreate(Utility.bigGlassDefaultName, Utility.bigGlassDefaultValue);
    this.storage.setOrCreate(Utility.smallGlassDefaultName, Utility.smallGlassDefaultValue);
    this.storage.setOrCreate(Utility.waterLevel, 0);
    this.storage.setOrCreate(Utility.dataReady, false);

    this.initialize(context).then(() => {
      this.scheduleDayCheck();
    }, (error: Error) => {
      hilog.error(0x0000, 'WaterKeeper', 'Failed to load water data: %{public}s', String(error));
    });
  }

  private prepareDateForUID(): string {
    return new Date().toLocaleDateString('en-GB');
  }

  private async initialize(context: Context): Promise<void> {
    try {
      const dataPreferences = await preferences.getPreferences(context, Utility.preferencesName);
      const bigGlass = await dataPreferences.get(Utility.bigGlassDefaultName, Utility.bigGlassDefaultValue) as number;
      const smallGlass = await dataPreferences.get(Utility.smallGlassDefaultName, Utility.smallGlassDefaultValue) as number;
      const today = this.prepareDateForUID();
      const waterLevel = await dataPreferences.get(today, 0) as number;

      this.dataPreferences = dataPreferences;
      this.currentDate = today;
      this.storage.setOrCreate(Utility.bigGlassDefaultName, bigGlass);
      this.storage.setOrCreate(Utility.smallGlassDefaultName, smallGlass);
      this.storage.setOrCreate(Utility.waterLevel, waterLevel);
      this.storage.setOrCreate(Utility.dataReady, true);
    } catch (error) {
      this.storage.setOrCreate(Utility.dataReady, false);
      throw new Error('Failed to read saved water data: ' + String(error));
    }
  }

  private async persistCurrentValues(): Promise<void> {
    const dataPreferences = this.dataPreferences;
    if (!dataPreferences) {
      return;
    }

    const bigGlass = this.storage.get(Utility.bigGlassDefaultName) as number;
    const smallGlass = this.storage.get(Utility.smallGlassDefaultName) as number;
    const waterLevel = this.storage.get(Utility.waterLevel) as number;
    const currentDate = this.currentDate;
    try {
      await dataPreferences.put(Utility.bigGlassDefaultName, bigGlass);
      await dataPreferences.put(Utility.smallGlassDefaultName, smallGlass);
      await dataPreferences.put(currentDate, waterLevel);
      await dataPreferences.flush();
    } catch (error) {
      throw new Error('Failed to write water data: ' + String(error));
    }
  }

  async saveToPersistence(): Promise<void> {
    if (this.storage.get(Utility.dataReady) as boolean) {
      await this.persistCurrentValues();
    }
  }

  async refreshCurrentDay(): Promise<void> {
    if (!this.dataPreferences || this.isTransitioning) {
      return;
    }

    const today = this.prepareDateForUID();
    if (today === this.currentDate) {
      return;
    }

    this.isTransitioning = true;
    this.storage.setOrCreate(Utility.dataReady, false);
    try {
      await this.persistCurrentValues();
      let waterLevel: number;
      try {
        waterLevel = await this.dataPreferences.get(today, 0) as number;
      } catch (error) {
        throw new Error('Failed to read water total for ' + today + ': ' + String(error));
      }
      this.currentDate = today;
      this.storage.setOrCreate(Utility.waterLevel, waterLevel);
      this.storage.setOrCreate(Utility.dataReady, true);
    } finally {
      this.isTransitioning = false;
    }
  }

  private scheduleDayCheck(): void {
    if (this.isDisposed) {
      return;
    }
    if (this.dayTimer !== undefined) {
      clearTimeout(this.dayTimer);
    }

    const nextMidnight = new Date();
    nextMidnight.setHours(24, 0, 0, 0);
    const delay = this.prepareDateForUID() === this.currentDate ?
      Math.max(1000, nextMidnight.getTime() - Date.now() + 1000) : 60000;
    this.dayTimer = setTimeout(() => {
      this.refreshCurrentDay().then(() => {
        this.scheduleDayCheck();
      }, (error: Error) => {
        hilog.error(0x0000, 'WaterKeeper', 'Failed to change day: %{public}s', String(error));
        this.scheduleDayCheck();
      });
    }, delay);
  }

  dispose(): void {
    this.isDisposed = true;
    if (this.dayTimer !== undefined) {
      clearTimeout(this.dayTimer);
      this.dayTimer = undefined;
    }
  }
}
