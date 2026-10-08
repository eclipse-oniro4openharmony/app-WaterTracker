import { Utility } from '../model/Utility';

interface QuantityButtonOptions {
  label: string;
  enabled: boolean;
  action: () => void;
}

const storage = LocalStorage.getShared();

@Entry(storage)
@Component
struct AddWaterMenu {
  @State private bigGlassAmount: number = 0;
  @State private smallGlassAmount: number = 0;
  @State private customAmount: number = 0;
  @State private sumOfWater: number = 0;
  @LocalStorageLink('water_level') private waterLevelInMilliLiters: number = 0;
  @LocalStorageProp('data_ready') private dataReady: boolean = false;
  @LocalStorageLink('small_glass_default') private defaultSmallGlass: number = Utility.smallGlassDefaultValue;
  @LocalStorageLink('big_glass_default') private bigGlassDefault: number = Utility.bigGlassDefaultValue;

  private calculateWater(): void {
    this.sumOfWater = this.bigGlassAmount * this.bigGlassDefault +
      this.smallGlassAmount * this.defaultSmallGlass + this.customAmount;
  }

  private saveWater(): void {
    if (!(storage.get(Utility.dataReady) as boolean) || this.sumOfWater <= 0) {
      return;
    }
    this.waterLevelInMilliLiters += this.sumOfWater;
    storage.set(Utility.waterLevel, this.waterLevelInMilliLiters);
    this.getUIContext().getRouter().back();
  }

  @Builder
  private quantityButton(options: QuantityButtonOptions) {
    Button(options.label)
      .width(42)
      .height(42)
      .fontSize(24)
      .fontColor(options.enabled ? $r('app.color.purple') : $r('app.color.muted'))
      .backgroundColor($r('app.color.page'))
      .borderRadius(14)
      .enabled(options.enabled)
      .onClick(options.action)
  }

  build() {
    Column() {
      Row() {
        Button('‹')
          .width(44)
          .height(44)
          .fontSize(30)
          .fontColor($r('app.color.ink'))
          .backgroundColor($r('app.color.surface'))
          .borderRadius(15)
          .onClick(() => this.getUIContext().getRouter().back())

        Text('Add water')
          .fontSize(26)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.ink'))
          .margin({ left: 16 })
      }
      .width('100%')
      .margin({ bottom: 24 })

      Column({ space: 14 }) {
          Row() {
            Column({ space: 4 }) {
              Text('Large glass')
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .fontColor($r('app.color.ink'))
              Text(this.bigGlassDefault.toString() + ' ml each')
                .fontSize(14)
                .fontColor($r('app.color.muted'))
            }
            .alignItems(HorizontalAlign.Start)

            Blank()

            this.quantityButton({ label: '−', enabled: this.bigGlassAmount > 0, action: () => {
              if (this.bigGlassAmount > 0) {
                this.bigGlassAmount--;
                this.calculateWater();
              }
            } })
            Text(this.bigGlassAmount.toString())
              .width(34)
              .textAlign(TextAlign.Center)
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.ink'))
            this.quantityButton({ label: '+', enabled: true, action: () => {
              this.bigGlassAmount++;
              this.calculateWater();
            } })
          }
          .width('100%')
          .padding(18)
          .backgroundColor($r('app.color.surface'))
          .borderRadius(20)

          Row() {
            Column({ space: 4 }) {
              Text('Small glass')
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .fontColor($r('app.color.ink'))
              Text(this.defaultSmallGlass.toString() + ' ml each')
                .fontSize(14)
                .fontColor($r('app.color.muted'))
            }
            .alignItems(HorizontalAlign.Start)

            Blank()

            this.quantityButton({ label: '−', enabled: this.smallGlassAmount > 0, action: () => {
              if (this.smallGlassAmount > 0) {
                this.smallGlassAmount--;
                this.calculateWater();
              }
            } })
            Text(this.smallGlassAmount.toString())
              .width(34)
              .textAlign(TextAlign.Center)
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.ink'))
            this.quantityButton({ label: '+', enabled: true, action: () => {
              this.smallGlassAmount++;
              this.calculateWater();
            } })
          }
          .width('100%')
          .padding(18)
          .backgroundColor($r('app.color.surface'))
          .borderRadius(20)

          Column({ space: 12 }) {
            Text('Custom amount')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('app.color.ink'))
              .width('100%')

            TextInput({ placeholder: '0' })
              .type(InputType.Number)
              .inputFilter('[0-9]*')
              .fontSize(18)
              .fontColor($r('app.color.ink'))
              .backgroundColor($r('app.color.page'))
              .borderRadius(14)
              .height(50)
              .onChange((value: string) => {
                const amount = Number.parseInt(value);
                this.customAmount = Number.isNaN(amount) ? 0 : Math.max(0, amount);
                this.calculateWater();
              })
            Text('ml')
              .fontSize(14)
              .fontColor($r('app.color.muted'))
              .width('100%')
          }
          .alignItems(HorizontalAlign.Start)
          .width('100%')
          .padding(18)
          .backgroundColor($r('app.color.surface'))
          .borderRadius(20)
      }
      .width('100%')

      Blank()

      Row() {
        Text('Total to add')
          .fontSize(16)
          .fontColor($r('app.color.muted'))
        Blank()
        Text(this.sumOfWater.toString() + ' ml')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.ink'))
      }
      .width('100%')
      .margin({ top: 18, bottom: 16 })

      Button('Add ' + this.sumOfWater.toString() + ' ml')
        .width('100%')
        .height(58)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.surface'))
        .backgroundColor(this.sumOfWater > 0 ? $r('app.color.purple') : $r('app.color.muted'))
        .borderRadius(18)
        .enabled(this.dataReady && this.sumOfWater > 0)
        .onClick(() => this.saveWater())
    }
    .width('100%')
    .height('100%')
    .padding({ top: 24, bottom: 24, left: 24, right: 24 })
    .backgroundColor($r('app.color.page'))
  }
}
