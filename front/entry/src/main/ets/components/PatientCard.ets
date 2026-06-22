import { Patient } from '../models/Patient'

@ComponentV2
export struct PatientCard {
  @Param patient: Patient | null = null

  build() {
    if (this.patient) {
      Column() {
        Row() {
          Text(this.patient.name).fontSize(18).fontWeight(FontWeight.Bold).fontColor('#303133')
          Blank()
          Text(this.patient.gender).fontSize(14).fontColor('#606266').margin({ right: 12 })
          Text(this.patient.age + '岁').fontSize(14).fontColor('#606266')
        }.width('100%').margin({ bottom: 8 })

        Row() {
          Text('病历号：').fontSize(13).fontColor('#909399')
          Text(this.patient.case_number).fontSize(13).fontColor('#303133').margin({ right: 20 })
          Text('身份证：').fontSize(13).fontColor('#909399')
          Text(this.patient.id_card).fontSize(13).fontColor('#303133')
        }.width('100%').margin({ bottom: 4 })

        Row() {
          Text('电话：').fontSize(13).fontColor('#909399')
          Text(this.patient.phone).fontSize(13).fontColor('#303133').margin({ right: 20 })
          Text('地址：').fontSize(13).fontColor('#909399')
          Text(this.patient.address).fontSize(13).fontColor('#303133')
        }.width('100%')
      }.width('100%').padding(16).backgroundColor('#F0F9FF').borderRadius(8)
      .border({ width: 1, color: '#BAE7FF' })
    }
  }
}
