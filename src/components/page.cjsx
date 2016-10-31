import { Tabbar } from '../components/tabbar'

export Layout = ({children}) ->
  <div className='layout-box'>
    { children }
  </div>

export Page = ({id, tab, children}) ->
  classes = util.cssClasses(
    'tabbar-labels-fixed' if tab
  )
  # <div className='views'>
  #   <div className='view'>
  #     <div className=''>
  #       <div className="page #{classes} navbar-fixed" id=id>
  #         { children }
  #         { <Tabbar activeTab=tab /> if tab }
  #       </div>
  #     </div>
  #   </div>
  # </div>

  <div className="page #{classes} navbar-fixed" id=id>
    { children }
    { <Tabbar activeTab=tab /> if tab }
  </div>

Page.Body = Body = ({wrapper, padding, id, children}) ->
  classes = util.cssClasses(
    'page-content' if wrapper,
    'page-padding' if padding
  )
  <article id=id className=classes>
    { children }
  </article>
