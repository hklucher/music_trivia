import React from "react"
import ReactDOM from "react-dom"
import {Response} from "./response"

export class ResponsesBox extends React.Component {
  constructor(props) {
    super(props);
    this.state = {selected: ''};
  }

  render() {
    if (this.props.responses) {
      const _this = this;
      var responsesList = this.props.responses.map(function(resp) {
        return (
          <div key={resp.id}>
            <Response
              key={resp.id}
              content={resp.content}
              selected={_this.state.selected}
              id={resp.id}
              handleChange={_this.handleChange.bind(_this)}>
            </Response>
            <br/>
          </div>
        )
      })
      return (
        <form action="">
          {responsesList}
        </form>
      )
    } else {
      return (<div></div>)
    }
  }

  handleChange(selectedValue) {
    this.setState({selected: selectedValue});
    this.props.handleChange(selectedValue)
  }
}
