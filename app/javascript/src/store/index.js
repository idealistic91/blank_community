export default {
  state: {
    csrfToken: undefined,
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
    drawerState: (state) => state.drawerState,
    csrfToken: (state) => state.csrfToken
  },
  mutations: {
    setCsrfToken (state, token) {
      state.csrfToken = token
    },
    toggleDrawerState (state, data) {
      state.drawerState = data
    },
    setUser (state, user) {
      state.user = user
      state.loggedIn = true
    },
    login (state) {
      state.loggedIn = true
    },
    logout (state) {
      state.loggedIn = false
    },
    toggleLogin (state) {
      state.loggedIn = !state.loggedIn
    },
    setCommunity (state, community) {
      state.community = community
    }
  }
}