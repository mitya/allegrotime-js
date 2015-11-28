defineComponent 'Schedule',
  render: ->
    <UI.Page padded=yes id="schedule">
      <UI.Navbar>
        <UI.NavbarButton side='left' />
        <UI.NavbarTitle value="Расписание" />
      </UI.Navbar>

      <UI.Body>
        <UI.ScheduleGraph />
        <UI.ScheduleTable />
      </UI.Body>
    </UI.Page>
