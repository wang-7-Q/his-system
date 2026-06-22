const STATUS_COLORS: Record<string, string> = {
  '已缴费': '#67C23A',
  '未缴费': '#F56C6C',
  '已完成': '#409EFF',
  '待处理': '#E6A23C',
  '已退费': '#909399',
  '已发药': '#67C23A',
  '未发药': '#F56C6C',
  '已退药': '#909399',
  '待检查': '#E6A23C',
  '待检验': '#E6A23C',
  '待处置': '#E6A23C',
}

@ComponentV2
export struct StatusBadge {
  @Param status: string = ''

  @Computed
  get bgColor(): string {
    return STATUS_COLORS[this.status] || '#909399'
  }

  build() {
    Text(this.status)
      .fontSize(12)
      .fontColor('#FFFFFF')
      .padding({ left: 8, right: 8, top: 2, bottom: 2 })
      .borderRadius(4)
      .backgroundColor(this.bgColor)
  }
}
