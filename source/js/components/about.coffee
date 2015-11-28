defineComponent 'About',
  render: ->
    # cordova.getAppVersion?.getVersionNumber (version) ->
    #   $('#about span.app-version').text version

    <UI.Page padded=yes tabbar=no id="about">

      <UI.Navbar>
        <UI.NavbarBackButton to='/' />
        <UI.NavbarTitle value = 'О Приложении'/>
      </UI.Navbar>

      <UI.Body>
        <h4 className="page-title">
          <span className="app-name">АллегроТайм</span> <span className="app-version">0.0.0</span>
        </h4>

        <p>
          асписание «Аллегро» и «Ласточки» обновлено <span className="schedule-update-ts">{Schedule.current.updated_at}</span>.
        </p>

        <p className="ios-only">
          <a href="itms-apps://itunes.apple.com/app/id524992172">Оцените приложение или напишите отзыв!</a>
        </p>

        <p className="android-only">
          <a href="market://details?id=name.sokurenko.AllegroTime">Оцените приложение или напишите отзыв!</a>
        </p>

        <p>
          Отправляйте ваши замечания или предложения на
          <a href="mailto:allegrotime@yandex.ru">allegrotime@yandex.ru</a>
          или оставьте комментарий на
          <a href="https://allegrotime.firebaseapp.com/comments.html">
            https://allegrotime.firebaseapp.com/comments.html
          </a>
        </p>

        <p>
          На этот же адрес можно отправить фотографию синей таблички около переезда,
          если вы видите что расписание в приложении существенно не похоже на то что есть на самом деле.
          Мы обязательно его обновим. Со временем :)
        </p>
      </UI.Body>

    </UI.Page>
