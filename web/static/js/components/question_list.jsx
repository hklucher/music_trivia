import React from "react"
import ReactDOM from "react-dom"

export class QuestionList extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    const _this = this;
    var questionList = this.props.questions.map(function(quest, index) {
      return (
        <tr key={quest.id}>
          <td>{index + 1}</td>
          <td>{quest.content}</td>
          <td>"A response will go here..."</td>
          <td>"An answer will go here..."</td>
          <td>"An icon indicating whether or not it was correct will go here"</td>
        </tr>
      )
    })
    return (
      <table className="question_results_table">
        <thead>
          <td>#</td>
          <td>Question</td>
          <td>Your Response</td>
          <td>Correct Answer</td>
          <td>Correct?</td>
        </thead>
        <tbody>
          {questionList}
        </tbody>
      </table>
    )
  }
}

QuestionList.propTypes = {
  questions: React.PropTypes.array
}
