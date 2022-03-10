import tobackend from '~/plugins/2backend.js'

export default function({ store, redirect }) {
  if (tobackend.isLoggedIn(store)) {
    return redirect('/login')
  }
}
