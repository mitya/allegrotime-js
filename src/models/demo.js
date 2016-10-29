class Foo {
  constructor() {
    console.log("foo created")
  }

  // privateMethod = (x) => {
  //   console.log("private method called", this, x)
  // }

  // saveSSHKey = (sshKey) => {
  //   this.setState({ sshKey });
  // }

  publicMethod() {
    console.log("public method called", this)
    this.privateMethod('a param')
  }
}
