class Rack::Attack
  # Allow all local traffic
  safelist('allow-localhost') do |req|
    '127.0.0.1' == req.ip || '::1' == req.ip
  end

  # Throttle login attempts by IP (5 requests per minute)
  throttle('limit logins', limit: 5, period: 60.seconds) do |req|
    if req.path == '/api/login' && req.post?
      req.ip
    end
  end

  # Optional: custom block response
  self.throttled_response = lambda do |env|
    [ 429,  # status
      { 'Content-Type' => 'application/json' },
      [ { error: 'Too many login attempts. Please try again later.' }.to_json ]
    ]
  end
end
