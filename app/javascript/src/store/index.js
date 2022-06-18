export default {
  state: {
    drawerState: false,
    community: undefined,
    user: undefined,
  },
  getters: {
    user: state => {
      return state.user
    },
    community: state => {
      return state.community
    },
    drawerState: (state) => state.drawerState
  },
  mutations: {
    toggleDrawerState (state, data) {
      state.drawerState = data
    },
    setUser (state, user) {
      state.user = user
    },
    setCommunity (state, community) {
      state.community = community
    }
  }
}