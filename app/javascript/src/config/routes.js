import Events from '../views/Events'
import MyCommunities from '../views/MyCommunities'
import Login from '../views/Login'

export default {
    routes: [
        { path: '/login', component: Login },
        { path: '/my-communities', component: MyCommunities },
        { path: '/events', component: Events }
    ]
}