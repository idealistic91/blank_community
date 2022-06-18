export default {
  state: {
    loggedIn: false,
    drawerState: false,
    community: undefined,
    user: undefined,
  },
  getters: {
    user: state => {
      return state.user
    },
    loggedIn: state => {
      return state.loggedIn
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
      state.loggedIn = true
    },
    toggleLogin (state) {
      state.loggedIn = !state.loggedIn
    },
    setCommunity (state, community) {
      state.community = community
    }
  }
}