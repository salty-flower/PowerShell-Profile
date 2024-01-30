Register-ArgumentCompleter -CommandName Step-CourseDirectory,scd -ParameterName CourseCode -ScriptBlock {
  param($commandName,$parameterName,$wordToComplete,$commandAst,$fakeBoundParameter)
  Get-ChildItem -Path $env:CURRENT_COURSE_HOME -Filter "*$wordToComplete*" -Directory | ForEach-Object {
    [System.Management.Automation.CompletionResult]::new(
      $_.Name,
      $_.Name,
      [CompletionResultType]::ParameterValue,
      $_
    )
  }
}
