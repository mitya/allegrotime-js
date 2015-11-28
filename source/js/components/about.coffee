UI.About = React.createClass
  displayName: 'About'
  render: ->
    # cordova.getAppVersion?.getVersionNumber (version) ->
    #   $('#about span.app-version').text version

    <div className="page page-padded no-tabbar">

      <div className="navbar-box" id="navbar">
        <ul className="navbar">
          <li className="buttons left">
            <Link to="/status">
              <img className='back-button' src='images/icons/custom_back.png' height=20 width=20 />
            </Link>
          </li>
          <li className="title">
            <span className="brand">О Приложении</span>
          </li>
          <li className="buttons right"></li>
        </ul>
      </div>

      <div className="page-content" id="about">
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
      </div>

    </div>

  back: ->
    App.status_view.update()
