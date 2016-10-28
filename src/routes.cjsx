import { Router, Route, IndexRoute, useRouterHistory, hashHistory } from 'react-router'
import { createHashHistory } from 'history'
import { render } from 'react-dom'

history = null

export setupRoutes = ->
  # @history = ReactHistory.createHashHistory(queryKey: false)
  # @history = useRouterHistory(createHashHistory)(queryKey: false)
  # @history = ReactRouter.useRouterHistory(ReactHistory.createHashHistory)(queryKey: false)
  history = hashHistory
  render(
    <Router history=history>
      <Route path="/" component={CLayout}>
        <IndexRoute component={CStatus}/>
        <Route path="about" component={CAbout}/>
        <Route path="status" component={CStatus}/>
        <Route path="crossings" component={CCrossings}/>
        <Route path="schedule" component={CSchedule}/>
      </Route>
    </Router>
    document.getElementById('application')
  )

export getHistory = ->
  history
