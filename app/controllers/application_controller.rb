class ApplicationController < ActionController::Base
  RECENT = {
    :'1hour' => 1.hour,
    :'1day' => 1.day,
    :'1week' => 1.week,
    :'1month' => 1.month
  }
  RECENT.default = 1.day

  protect_from_forgery

end
