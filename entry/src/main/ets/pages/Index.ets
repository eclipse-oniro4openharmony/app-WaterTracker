import { Utility } from '../model/Utility';

@Entry({ useSharedStorage: true })
@Component
struct Index {
  @LocalStorageProp('water_level') private waterState: number = 0;
  @LocalStorageProp('data_ready') private dataReady: boolean = false;

  private getGlassLevel(): number {
    if (this.waterState <= 0) {
      return 0;
    }
    if (this.waterState < 750) {
      return 1;
    }
    if (this.waterState < 1250) {
      return 2;
    }
    if (this.waterState < Utility.dailyGlassGoal) {
      return 3;
    }
    return 4;
  }

  private getGlassImage(): Resource {
    switch (this.getGlassLevel()) {
      case 0:
        return $r('app.media.glass00');
      case 1:
        return $r('app.media.glass01');
      case 2:
        return $r('app.media.glass02');
      case 3:
        return $r('app.media.glass03');
      default:
        return $r('app.media.glass04');
    }
  }

  build() {
    Column() {
      Row() {
        Text('Today')
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.ink'))

        Blank()

        Button('Settings')
          .id('settings')
          .fontSize(15)
          .fontColor($r('app.color.purple'))
          .backgroundColor($r('app.color.surface'))
          .borderRadius(16)
          .height(44)
          .enabled(this.dataReady)
          .onClick(() => {
            this.getUIContext().getRouter().pushUrl({ url: 'pages/SettingsMenu' });
          })
      }
      .width('100%')
      .margin({ bottom: 22 })

      Column({ space: 4 }) {
        Image(this.getGlassImage())
          .width(174)
          .height(208)
          .objectFit(ImageFit.Contain)

        Text(this.waterState.toString())
          .fontSize(58)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.ink'))

        Text('ml logged today')
          .fontSize(16)
          .fontColor($r('app.color.muted'))

        Text('Goal: 2,000 ml')
          .fontSize(14)
          .fontColor($r('app.color.muted'))
          .margin({ top: 10 })
      }
      .width('100%')
      .padding({ top: 18, bottom: 30, left: 20, right: 20 })
      .backgroundColor($r('app.color.surface'))
      .borderRadius(28)

      Blank()

      Button('Add water')
        .width('100%')
        .height(58)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.surface'))
        .backgroundColor($r('app.color.purple'))
        .borderRadius(18)
        .enabled(this.dataReady)
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/AddWaterMenu' });
        })
    }
    .width('100%')
    .height('100%')
    .padding({ top: 24, bottom: 24, left: 24, right: 24 })
    .backgroundColor($r('app.color.page'))
  }
}
