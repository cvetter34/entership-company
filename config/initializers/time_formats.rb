Time::DATE_FORMATS[:month_and_year] = '%B %Y'
Time::DATE_FORMATS[:table_date] = '%-d %b %Y'
Time::DATE_FORMATS[:birth_date] = '%-d %B %Y'
Time::DATE_FORMATS[:short_ordinal]  = ->(time) { time.strftime("%B #{time.day.ordinalize}") }
Time::DATE_FORMATS[:chat_date] = '%l:%M %p on %A, %-d %B %Y'
Time::DATE_FORMATS[:message_time] = '<span class="mtime">%l:%M %p</span> on <span class="mdate">%A, %-d %B %Y</span>'
Time::DATE_FORMATS[:mail_timestamp] = "%a %-d %b %Y %-I:%M %p"

Date::DATE_FORMATS[:birth_date] = '%-d %B %Y'
Date::DATE_FORMATS[:closing_date] = '%-d %b %Y'
Date::DATE_FORMATS[:table_date] = '%-d %b %Y'
