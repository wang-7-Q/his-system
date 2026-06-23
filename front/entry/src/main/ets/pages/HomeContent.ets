import { User } from '../models/User'
import { Constants } from '../common/Constants'

/**
 * Dashboard-style home page with welcome card, stats, and quick actions.
 */
@ComponentV2
struct HomeContent {
  @Local loginUser: User | null = null
  @Local todayDate: string = ''

  aboutToAppear(): void {
    this.loginUser = AppStorage.get<User>('loginUser') || null
    const now: Date = new Date()
    const y: number = now.getFullYear()
    const m: number = now.getMonth() + 1
    const d: number = now.getDate()
    const weekDays: string[] = ['日', '一', '二', '三', '四', '五', '六']
    const w: string = weekDays[now.getDay()]
    this.todayDate = `${y}年${m}月${d}日 星期${w}`
  }

  build() {
    Scroll() {
      Column() {
        // ── Welcome card ──
        Row() {
          Column() {
            Text('早安，' + (this.loginUser?.realname || '用户'))
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FFFFFF')
            Text(this.loginUser?.dept_name || '')
              .fontSize(13)
              .fontColor('rgba(255,255,255,0.75)')
              .margin({ top: 4 })
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          Column() {
            Text(this.todayDate)
              .fontSize(12)
              .fontColor('rgba(255,255,255,0.75)')
          }
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 24, bottom: 24 })
        .borderRadius(16)
        .linearGradient({
          direction: GradientDirection.Right,
          colors: [['#1677FF', 0], ['#4096FF', 1]],
        })
        .margin({ bottom: 16 })

        // ── Stats row ──
        Row() {
          this.statCard('今日挂号', '--', Constants.COLOR_PRIMARY)
          this.statCard('门诊接诊', '--', Constants.COLOR_SUCCESS)
          this.statCard('待办事项', '--', Constants.COLOR_WARNING)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ bottom: 16 })

        // ── Quick actions ──
        Column() {
          Text('快捷操作')
            .fontSize(15)
            .fontWeight(FontWeight.Medium)
            .fontColor(Constants.COLOR_TEXT_PRIMARY)
            .margin({ bottom: 12 })
            .alignSelf(ItemAlign.Start)

          Grid() {
            GridItem() {
              this.quickAction('📋', '现场挂号')
            }
            GridItem() {
              this.quickAction('💰', '费用收取')
            }
            GridItem() {
              this.quickAction('💊', '药品发放')
            }
            GridItem() {
              this.quickAction('🔍', '记录查询')
            }
          }
          .columnsTemplate('1fr 1fr 1fr 1fr')
          .rowsGap(8)
          .columnsGap(8)
          .width('100%')
        }
        .width('100%')
        .padding(16)
        .borderRadius(12)
        .backgroundColor(Constants.COLOR_CARD)
        .margin({ bottom: 16 })

        // ── System notice ──
        Column() {
          Row() {
            Text('📢')
              .fontSize(18)
              .margin({ right: 8 })
            Text('系统公告')
              .fontSize(15)
              .fontWeight(FontWeight.Medium)
              .fontColor(Constants.COLOR_TEXT_PRIMARY)
          }
          .width('100%')
          .margin({ bottom: 12 })

          Text('欢迎使用东软云医院信息系统。请使用已分配的科室账号登录系统，如有疑问请联系系统管理员。')
            .fontSize(13)
            .fontColor(Constants.COLOR_TEXT_SECONDARY)
            .lineHeight(20)
            .width('100%')
        }
        .width('100%')
        .padding(16)
        .borderRadius(12)
        .backgroundColor(Constants.COLOR_CARD)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 80 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Constants.COLOR_BG)
  }

  @Builder
  statCard(label: string, value: string, color: string) {
    Column() {
      Text(value)
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor(color)
      Text(label)
        .fontSize(12)
        .fontColor(Constants.COLOR_TEXT_HINT)
        .margin({ top: 4 })
    }
    .width('30%')
    .padding({ top: 16, bottom: 16 })
    .borderRadius(10)
    .backgroundColor(Constants.COLOR_CARD)
  }

  @Builder
  quickAction(icon: string, label: string) {
    Column() {
      Text(icon)
        .fontSize(28)
        .margin({ bottom: 6 })
      Text(label)
        .fontSize(12)
        .fontColor(Constants.COLOR_TEXT_SECONDARY)
    }
    .width('100%')
    .padding({ top: 14, bottom: 14 })
    .borderRadius(10)
    .backgroundColor(Constants.COLOR_BG)
    .onClick(() => {
      // Quick actions navigate to Workbench tab — handled by parent
    })
  }
}

export default HomeContent
