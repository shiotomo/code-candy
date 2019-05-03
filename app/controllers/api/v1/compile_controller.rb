require './lib/code_candy/code_runner'
require './lib/code_candy/language'

class Api::V1::CompileController < Api::ApiController
  before_action :authenticate_user!

  def exec
    # 送られてきたパラメータを変数に格納
    language = params[:language]
    source_code = params[:source_code]
    input = params[:input]

    code_runner = CodeCandy::CodeRunner.new(language, source_code, input, current_user.id)

    begin
      submit_language = CodeCandy::Language.get_language_data[:"#{language}"][:language]
      # 提出されたコードを保存
      @result = code_runner.exec
      # 入力が不正な場合はレコードしない
      Code.create(code: source_code, language: submit_language, user_id: current_user.id) unless @result[:input_error]
    rescue
      @result = {stdout: "Error",stderr: "入力が不正です。", time: "", exit_code: 1, input_error: true}
    end

    @result[:stdout] = @result[:stdout].force_encoding("UTF-8")
    @result[:stderr] = @result[:stderr].force_encoding("UTF-8")

    render json: @result
  end
end
