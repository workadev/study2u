# Return an array to customize <option> text, `value` and other HTML attributes
CountrySelect::FORMATS[:alpha2] = lambda do |country|
  [
    country.iso_short_name,
    country.iso_short_name
  ]
end