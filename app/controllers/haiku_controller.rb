class HaikuController < ActionController::API

  def haiku
    create_haiku(params[:input])
  end

  private

  def create_haiku text
    return not_found unless text

    words = text.gsub(/[,\.\?\!]/, '').upcase.split(/\s/)
    words_raw = text.split(/\s/)
    return not_found if words.length > 20

    syllables = words.map { |word| SYLLABLES[word]&.to_i }
    return not_found if syllables.include?(nil)
    return not_found unless syllables.reduce(:+) == 17

    lines = [[], [], []]
    syllable_count = [0,0,0]

    words.each_with_index do |word, i|
      if(syllables[i])
        if syllable_count[0] < 5
          lines[0] << words_raw[i]
          syllable_count[0] += syllables[i]
        elsif syllable_count[1] < 7
          lines[1] << words_raw[i]
          syllable_count[1] += syllables[i]
        else
          lines[2] << words_raw[i]
          syllable_count[2] += syllables[i]
        end
      end
      return not_found if syllable_count[0] > 5 || syllable_count[1] > 7 || syllable_count[2] > 5
    end
    return success(lines.map{|l| l.join(" ").capitalize}.join("\n"))
  end

  def success(haiku)
    json_response({status: "success", message: haiku})
  end

  def not_found
    json_response({status: "not_found", message: "No haiku detected"})
  end

  def json_response(object, status = :ok)
    render json: object, status: status
  end
end