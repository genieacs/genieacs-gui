Raphael.fn.pieChart = (cx, cy, r, values) ->
  paper = this
  rad = Math.PI / 180
  chart = this.set()

  sector = (cx, cy, r, startAngle, endAngle, params) ->
    x1 = cx + r * Math.cos(-startAngle * rad)
    x2 = cx + r * Math.cos(-endAngle * rad)
    y1 = cy + r * Math.sin(-startAngle * rad)
    y2 = cy + r * Math.sin(-endAngle * rad)
    p = paper.path(["M", cx, cy, "L", x1, y1, "A", r, r, 0, +(endAngle - startAngle > 180), 0, x2, y2, "z"])
    p.attr(params)
    return p

  angle = 0
  total = 0
  start = 0
  process = (j) ->
    value = values[j]
    angleplus = 360 * value.data / total
    popangle = angle + (angleplus / 2)
    color1 = Raphael.color(value.color)
    color2 = Raphael.hsb(color1.h, color1.s, color1.v * 0.8)
    ms = 100
    delta = -40
    p = sector(cx, cy, r, angle, angle + angleplus, {fill: "90-#{color2}-" + color1, stroke: 'white', 'stroke-width': 1, href: value.href})
    txt = paper.text(cx + (r + delta + 10) * Math.cos(-popangle * rad), cy + (r + delta + 0) * Math.sin(-popangle * rad), (value.data * 100 / total).toFixed(2) + '%').attr({fill: Raphael.hsb(color1.h, color1.s, color1.v * 0.5), 'font-weight': 'bold', stroke: "none", opacity: 0, "font-size": 12, href: value.href})

    mouseover = () ->
      p.toFront()
      p.stop().animate({stroke: '#046380'}, ms)
      txt.stop().animate({opacity: 1}, ms, "elastic").toFront()

    mouseout = () ->
      p.stop().animate({stroke: 'white' }, ms)
      txt.stop().animate({opacity: 0}, ms)

    p.mouseover(mouseover).mouseout(mouseout)
    txt.mouseover(mouseover).mouseout(mouseout)

    angle += angleplus
    chart.push(p)
    chart.push(txt)
    start += .1

  l = values.length
  for i in [0...l]
    total += values[i].data
  total += 0.001

  for i in [0...l]
    process(i)

  return chart

window.pieChart = (container, width, values) ->
  Raphael(container, width, width).pieChart(width/2, width/2, width * 0.4, values)
  total = 0
  for v in values
    total += v.data

  legend = $('<div class="legend"></div>')
  for v in values
    legend.append("<div><span style='color:#{v.color}'>&#x25CF;</span> #{v.label}: <a href='#{v.href}'>#{v.data}</a> (#{(v.data * 100 / total).toFixed(2)}%)</div>")
  legend.append("<div><b>Total</b>: #{total}</div>")
  $("##{container}").append(legend)