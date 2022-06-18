import axios from 'axios'

export async function login(csrf, email, password) {
  // Route to api only controller, switch to later if we store vue in own app
  //const response = await axios.post(`/api/v1/sessions?email=${email}&password=${password}`)
  let config = {
    headers: {
      'X-CSRF-Token': csrf
    }
  }

  const response = await axios.post(`/users/sign_in?format=json`, {user: {email: email, password: password}}, config)
  return response.data
}

export async function logout(auth_token) {
  const response = await axios.delete(`/api/v1/sessions/${auth_token}`);
  return response.data
}

export async function register() {

}
