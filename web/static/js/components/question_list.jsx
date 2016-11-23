import React from "react"
import ReactDOM from "react-dom"

export class QuestionList extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    const _this = this;
    let questionList = this.props.questions.map(function(quest, index) {
      return (
        <div key={quest.id}>
          <h3>Question {index + 1} {_this._correctnessIcon(quest)}</h3>
          <ul>
            {_this._mapResponses(quest)}
          </ul>
        </div>
      )
    });
    return (
      <div>
        {questionList}
      </div>
    )
  }

  _correctnessIcon(question) {
    if (this._gotQuestionRight(question)) {
      return <i className="fa fa-check-circle-o" aria-hidden="true"></i>;
    } else {
      return <i className="fa fa-times-circle" aria-hidden="true"></i>;
    }
  }

  _gotQuestionRight(question) {
    return question.answer.content === question.userResponse;
  }

  _mapResponses(question) {
    let responseList = question.responses.map(function(resp) {
      return (<li key={resp.id}>{resp.content}</li>)
    });
    return responseList;
  }
}


QuestionList.propTypes = {
  questions: React.PropTypes.array
}
