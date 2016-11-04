import React from "react"
import ReactDOM from "react-dom"

class QuizBox extends React.Component {
  render() {
    return (<h1>Quiz</h1>)
  }

  componentDidMount() {
    this.loadQuizFromServer();
  }

  loadQuizFromServer() {
  }
}

ReactDOM.render(
  <QuizBox/>, document.getElementById("quiz_container")
)
