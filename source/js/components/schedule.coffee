defineComponent 'Schedule',
  render: ->
    <CPage padded=yes id="schedule">
      <CNavbar>
        <CNavbarButton side='left' />
        <CNavbarTitle value="Расписание" />
      </CNavbar>

      <CBody>
        <CScheduleGraph />
        <CScheduleTable />
      </CBody>
    </CPage>
