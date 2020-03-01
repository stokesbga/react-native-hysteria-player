import { StyleSheet } from 'react-native'

export default StyleSheet.create({
  container: {
    flex: 1,
  },

  wrapper: {
    flex: 1,
    minHeight: 50,
    alignItems: "center",
    justifyContent: "center"
  },

  wrapperNoFlex: {
    flex: 0,
    alignItems: "center",
    justifyContent: "center"
  }
});