import { window } from '@kit.ArkUI'

export enum BreakpointType {
  SM = 'sm',
  MD = 'md',
  LG = 'lg',
}

export class BreakpointSystem {
  static updateBreakpoint(windowClass: window.Window): void {
    const width: number = windowClass.getWindowProperties().windowRect.width
    const breakpoint: BreakpointType = BreakpointSystem.getBreakpoint(width)
    AppStorage.setOrCreate('currentBreakpoint', breakpoint)
  }

  static getBreakpoint(width: number): BreakpointType {
    if (width < 600) {
      return BreakpointType.SM
    }
    if (width < 840) {
      return BreakpointType.MD
    }
    return BreakpointType.LG
  }

  static isTablet(): boolean {
    const bp: string = AppStorage.get<string>('currentBreakpoint') as string
    return bp === BreakpointType.LG
  }
}
