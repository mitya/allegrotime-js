defineComponent 'Schedule',
  render: ->
    <CPage id='schedule' tab='schedule'>
      <CNavbar>
        <CNavbarButton side='left' />
        <CNavbarTitle value="Расписание" />
      </CNavbar>

      <CBody>
        <CScheduleGraph />
        <CScheduleTable />
      </CBody>
    </CPage>
