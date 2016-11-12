import React from "react"
import ReactDOM from "react-dom"

export class Response extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    console.log(this.props);
    return (
      <label>
        <input
          type="radio"
          value={this.props.content}
          name={"response"}
          onChange={this.props.handleChange.bind(this)}/>
        {this.props.content}
      </label>
    )
  }
}
