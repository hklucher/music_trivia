import React from "react"
import ReactDOM from "react-dom"

export class QuestionsBox extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  render() {
    if (this.props.questions) {
      var questionsList = this.props.questions.map(function(question) {
        return <li key={question.id}>{question.content}</li>
      })
      return (
        <div>
          <ul>
            {questionsList}
          </ul>
        </div>
      )
    } else {
      return(<div></div>)
    }
  }
}
