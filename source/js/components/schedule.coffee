defineComponent 'Schedule',
  render: ->
    crossing = Crossing.current()

    <CPage id='schedule' tab='schedule'>
      <CNavbar>
        <CNavbarButton side='left' />
        <CNavbarTitle value="Расписание" />
      </CNavbar>

      <CBody>
        <CScheduleGraph crossing=crossing />
        <CScheduleTable crossing=crossing />
      </CBody>
    </CPage>
