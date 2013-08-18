// Generated by CoffeeScript 1.6.3
var Physics;

Physics = {
  collision: function(a, b) {
    if (a.max.x < b.min.x || a.min.x > b.max.x) {
      return false;
    }
    if (a.max.y < b.min.y || a.min.y > b.max.y) {
      return false;
    }
    return true;
  },
  combine: function(as) {
    var a, surface, _i, _len;
    surface = {
      min: {
        x: as[0].min.x,
        y: as[0].min.y
      },
      max: {
        x: as[0].max.x,
        y: as[0].max.y
      }
    };
    for (_i = 0, _len = as.length; _i < _len; _i++) {
      a = as[_i];
      if (a.min.x < surface.min.x) {
        surface.min.x = a.min.x;
      }
      if (a.min.y < surface.min.y) {
        surface.min.y = a.min.y;
      }
      if (a.max.x > surface.max.x) {
        surface.max.x = a.max.x;
      }
      if (a.max.y > surface.max.y) {
        surface.max.y = a.max.y;
      }
    }
    surface.x = surface.min.x + ((surface.max.x - surface.min.x) / 2);
    surface.y = surface.min.y + ((surface.max.y - surface.min.y) / 2);
    return surface;
  },
  overlap: function(a, b) {
    var ax_extent, ay_extent, bx_extent, by_extent, manifold, normalX, normalY, x_overlap, y_overlap;
    normalX = b.x - a.x;
    normalY = b.y - a.y;
    ax_extent = (a.max.x - a.min.x) / 2;
    bx_extent = (b.max.x - b.min.x) / 2;
    x_overlap = ax_extent + bx_extent - Math.abs(normalX);
    if (!(x_overlap > 0)) {
      return null;
    }
    ay_extent = (a.max.y - a.min.y) / 2;
    by_extent = (b.max.y - b.min.y) / 2;
    y_overlap = ay_extent + by_extent - Math.abs(normalY);
    if (!(y_overlap > 0)) {
      return null;
    }
    manifold = {
      onX: normalX,
      onY: normalY
    };
    if (x_overlap < y_overlap) {
      manifold.normalY = 0;
      manifold.penetration = x_overlap;
      if (normalX < 0) {
        manifold.normalX = -1;
      } else {
        manifold.normalX = 1;
      }
    } else {
      manifold.normalX = 0;
      manifold.penetration = y_overlap;
      if (normalY < 0) {
        manifold.normalY = -1;
      } else {
        manifold.normalY = 1;
      }
    }
    return manifold;
  },
  resolve: function(a, b, m) {
    var adx, ady, ax, ay, bbx, bby, bdx, bdy, c, e, impulseX, impulseY, j, percent, rvX, rvY, slop, vn;
    b.dx = 0;
    b.dy = 0;
    a.invmass = 1;
    b.invmass = 0;
    rvX = b.dx - a.dx;
    rvY = b.dy - a.dy;
    vn = rvX * m.normalX + rvY * m.normalY;
    if (vn > 0) {
      return null;
    }
    e = 0.5 * Math.abs(vn / a.maxSpeed);
    j = -(1 + e) * vn;
    j /= a.invmass + b.invmass;
    impulseX = m.normalX * j;
    impulseY = m.normalY * j;
    ax = bbx = ay = bby = 0;
    adx = -a.invmass * impulseX;
    ady = -a.invmass * impulseY;
    bdx = b.invmass * impulseX;
    bdy = b.invmass * impulseY;
    percent = Math.abs(vn / a.maxSpeed);
    slop = 0.01;
    c = Math.max(m.penetration - slop, 0);
    ax = -a.invmass * c * m.normalX;
    ay = -a.invmass * c * m.normalY;
    bbx = b.invmass * c * m.normalX;
    bby = b.invmass * c * m.normalY;
    return {
      a: [ax, ay, adx, ady],
      b: [bbx, bby, bdx, bdy]
    };
  }
};
