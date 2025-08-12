module HelpQueuesHelper
  def qr_code_for(help_queue)
    require 'rqrcode'

    url = short_help_request_url(help_queue.id)
    # url = "http://192.168.1.25:3000/hq/#{help_queue.id}"

    qrcode = RQRCode::QRCode.new(url)
    svg = qrcode.as_svg(
      offset: 0,
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 6,
      standalone: true
    )

    raw(svg)
  end
end