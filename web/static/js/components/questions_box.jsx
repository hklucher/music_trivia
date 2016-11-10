import React from "react"
import ReactDOM from "react-dom"
import {Question} from "./question"

export class QuestionsBox extends React.Component {
  constructor(props) {
    super(props);
    this.state = {};
  }

  render() {
    if (this.props.questions) {
      var questionsList = this.props.questions.map(function(question) {
        return (
            <li key={question.id}>
              <Question content={question.content} responses={question.responses}></Question>
            </li>
          )
      })
      return (
        <ul>
          {questionsList}
        </ul>
      )
    } else {
      return(<div></div>)
    }
  }
}
