import axios from 'axios'

export async function login(community, page = undefined, scope = undefined) {
  const response = await axios.get(`/communities/${community}/events?format=json`);
  return response.data
}

export async function logout(community, id) {
  const response = await axios.get(`/communities/${community}/events/${id}?format=json`);
  return response.data
}

export async function register() {
  
}
