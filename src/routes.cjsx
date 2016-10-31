{ createHashHistory } = ReactHistory
{ render } = ReactDOM
{ Router, Route, IndexRoute, useRouterHistory, hashHistory } = ReactRouter

import { Layout } from './components/page'
import { Status } from './pages/status'
import { About } from './pages/about'
import { Crossings } from './pages/crossings'
import { Schedule } from './pages/schedule'

history = null

export setupRoutes = ->
  # @history = ReactHistory.createHashHistory(queryKey: false)
  # @history = useRouterHistory(createHashHistory)(queryKey: false)
  # @history = ReactRouter.useRouterHistory(ReactHistory.createHashHistory)(queryKey: false)
  history = hashHistory
  render(
    <Router history=history>
      <Route path="/" component={Layout}>
        <IndexRoute component={Status}/>
        <Route path="about" component={About}/>
        <Route path="status" component={Status}/>
        <Route path="crossings" component={Crossings}/>
        <Route path="schedule" component={Schedule}/>
      </Route>
    </Router>
    document.getElementById('application')
  )

export getHistory = ->
  history
