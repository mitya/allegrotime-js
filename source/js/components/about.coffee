defineComponent 'About',
  componentDidMount: ->
    cordova.getAppVersion?.getVersionNumber (version) =>
      @setState version: version

  getInitialState: ->
    version: null

  render: ->
    updateTime = util.formatDate new Date(ds.schedule.updated_at)
    refreshTime = util.formatDateWithTime new Date(localStorage.checked_for_updates_at)

    <CPage padded=yes tab=no id='about'>

      <CNavbar>
        <CNavbarBackButton to='/' />
        <CNavbarTitle value='О Приложении'/>
      </CNavbar>

      <CBody wrapper=yes>
          <h4 className="page-title">
            <span className="app-name">АллегроТайм</span> <span className="app-version">{@state.version}</span>
          </h4>

          <p>
            Расписание «Аллегро» и «Ласточки» в вашем телефоне.
          </p>

          <p className="ios-only">
            <a href="itms-apps://itunes.apple.com/app/id524992172">Оцените приложение или напишите отзыв!</a>
          </p>

          <p className="android-only">
            <a href="market://details?id=name.sokurenko.AllegroTime">Оцените приложение или напишите отзыв!</a>
          </p>

          <p>
            Отправляйте ваши замечания или предложения на <a href="mailto:allegrotime@yandex.ru">allegrotime@yandex.ru</a> или
            оставьте комментарий на <a href="https://allegrotime.firebaseapp.com/comments.html">
              https://allegrotime.firebaseapp.com/comments.html
            </a>
          </p>

          <p>
            На этот же адрес можно отправить фотографию синей таблички около переезда,
            если вы видите что расписание в приложении существенно не похоже на то что есть на самом деле.
            Мы обязательно его обновим. Со временем :)
          </p>

          <p className='grayed'>
            Расписание обновлено: { updateTime }
          </p>

          <p className='grayed'>
            Обновления проверены: { refreshTime }
          </p>
      </CBody>

    </CPage>
