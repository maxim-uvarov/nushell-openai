use openai.nu results_record

export def main [
    prompt: string
    --path: path = '/Users/user/temp/llms/'
] {
    let $prompt_with_tick = $prompt | str replace -a '●' '`'
    let $answer = ( results_record $prompt_with_tick
        --system "Edit the message and correct grammar. Provide only the edited message. Don't change markdown markup."
    )

    let filename = now-fn

    let $prompt_path = $path | path join $'prompt($filename).txt'
    let $answer_path = $path | path join $'answer($filename).txt'

    $prompt_with_tick | save -f $prompt_path
    $answer | save -f $answer_path

    $answer_path | pbcopy

    codium --diff $prompt_path $answer_path
}

def 'now-fn' [
    --pretty (-P)
] {
    date now
    | format date (if $pretty { '%Y-%m-%d-%H:%M:%S' } else { '%Y%m%d-%H%M%S' })
}
