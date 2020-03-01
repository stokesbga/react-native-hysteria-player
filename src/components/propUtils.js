const textAlignStates = { "left": 0, "center": 1, "right": 2 }

export const textAlignFormat = (alignStr = "left") => {
  return textAlignStates?.[alignStr] || 0
}