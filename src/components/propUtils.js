import { processColor } from "react-native"
import resolveAssetSource from "react-native/Libraries/Image/resolveAssetSource"

const textAlignStates = { left: 0, center: 1, right: 2 }
const textAlignFormat = (alignStr = "left") => {
  return textAlignStates?.[alignStr] || 0
}

export const cleanProps = (props, baseStyle) => {
  let cleanedProps = {}
  Object.keys(props).map(propKey => {
    if (!props[propKey]) return
    const pKeyLower = propKey.toLowerCase(),
      val = props[propKey]

    // Colors
    if (pKeyLower.indexOf("color") > -1) {
      cleanedProps[propKey] = processColor(val)
      return
    }
    // Icons & Assets
    if (pKeyLower.indexOf("icon") > -1) {
      cleanedProps[propKey] = val
      return
    }
    // Text
    if (propKey === "textAlign") {
      cleanedProps[propKey] = textAlignFormat(val)
      return
    }
    // Style
    if (propKey === "style") {
      cleanedProps[propKey] = Array.isArray(val)
        ? [baseStyle, ...val]
        : [baseStyle, val]
      return
    }

    // Everything else
    cleanedProps[propKey] = props[propKey]
  })

  return cleanedProps
}
