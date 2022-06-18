import axios from 'axios'

export async function getEvents(community, page = undefined, scope = undefined) {
  const response = await axios.get(`/communities/${community}/events?format=json`);
  return response.data
}

export async function getEvent(community, id) {
  const response = await axios.get(`/communities/${community}/events/${id}?format=json`);
  return response.data
}
