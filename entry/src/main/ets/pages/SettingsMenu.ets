import { Utility } from '../model/Utility';

@Entry({ useSharedStorage: true })
@Component
struct SettingsMenu {
  @LocalStorageLink('small_glass_default') private defaultSmallGlass: number = Utility.smallGlassDefaultValue;
  @LocalStorageLink('big_glass_default') private defaultBigGlass: number = Utility.bigGlassDefaultValue;
  @LocalStorageProp('data_ready') private dataReady: boolean = false;
  @State private bigGlassInput: string = '';
  @State private smallGlassInput: string = '';

  onPageShow(): void {
    this.bigGlassInput = this.defaultBigGlass.toString();
    this.smallGlassInput = this.defaultSmallGlass.toString();
  }

  private updateBigGlass(value: string): void {
    this.bigGlassInput = value;
    const amount = Number.parseInt(value);
    if (!Number.isNaN(amount) && amount > 0) {
      this.defaultBigGlass = amount;
    }
  }

  private updateSmallGlass(value: string): void {
    this.smallGlassInput = value;
    const amount = Number.parseInt(value);
    if (!Number.isNaN(amount) && amount > 0) {
      this.defaultSmallGlass = amount;
    }
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

        Text('Settings')
          .fontSize(26)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.ink'))
          .margin({ left: 16 })
      }
      .width('100%')
      .margin({ bottom: 28 })

      Text('Glass sizes')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.ink'))
        .width('100%')
        .margin({ bottom: 16 })

      Column({ space: 14 }) {
        Column({ space: 12 }) {
          Text('Large glass')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.ink'))
            .width('100%')
          Row({ space: 10 }) {
            TextInput({ text: this.bigGlassInput })
              .type(InputType.Number)
              .enabled(this.dataReady)
              .inputFilter('[0-9]*')
              .layoutWeight(1)
              .height(50)
              .fontSize(18)
              .fontColor($r('app.color.ink'))
              .backgroundColor($r('app.color.page'))
              .borderRadius(14)
              .onChange((value: string) => this.updateBigGlass(value))
            Text('ml')
              .fontSize(16)
              .fontColor($r('app.color.muted'))
          }
          .width('100%')
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')
        .padding(18)
        .backgroundColor($r('app.color.surface'))
        .borderRadius(20)

        Column({ space: 12 }) {
          Text('Small glass')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.ink'))
            .width('100%')
          Row({ space: 10 }) {
            TextInput({ text: this.smallGlassInput })
              .type(InputType.Number)
              .enabled(this.dataReady)
              .inputFilter('[0-9]*')
              .layoutWeight(1)
              .height(50)
              .fontSize(18)
              .fontColor($r('app.color.ink'))
              .backgroundColor($r('app.color.page'))
              .borderRadius(14)
              .onChange((value: string) => this.updateSmallGlass(value))
            Text('ml')
              .fontSize(16)
              .fontColor($r('app.color.muted'))
          }
          .width('100%')
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')
        .padding(18)
        .backgroundColor($r('app.color.surface'))
        .borderRadius(20)
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .padding({ top: 24, bottom: 24, left: 24, right: 24 })
    .backgroundColor($r('app.color.page'))
  }
}
