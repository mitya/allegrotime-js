import { Page } from '../components/page'
import { Navbar } from '../components/navbar'

export class About extends React.Component
  constructor: ->
    super
    @state = version: null
  
  componentDidMount: ->
    cordova?.getAppVersion?.getVersionNumber (version) =>
      @setState version: version

    cordova?.getAppVersion?.getVersionCode (build) =>
      @setState build: build

  render: ->
    updateTime = $U.formatDate new Date(appState.schedule.updated_at)
    refreshTime = $U.formatDateWithTime new Date(localStorage.checked_for_updates_at)

    <Page padded=yes tab=no id='about'>
      <Navbar>
        <Navbar.BackButton to='/' />
        <Navbar.Title>О Приложении</Navbar.Title>
        <Navbar.ButtonStub />
      </Navbar>

      <Page.Body wrapper=yes padding=yes>
          <h4 className="page-title">
            <span className="app-name">АллегроТайм</span>{' '}
            <span className="app-version">{@state.version}{' '}
              <span className="app-build">({@state.build})</span>
            </span>
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
      </Page.Body>
    </Page>
