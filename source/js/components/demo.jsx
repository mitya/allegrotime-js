UI.ES6Test = React.createClass({
  displayName: 'ES6Test',
  render() {
    f = () => { console.log(123) }
    return <div className="demo">ES6 with JSX works!</div>
  }
})
