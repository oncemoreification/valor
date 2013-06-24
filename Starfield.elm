module Starfield (starLayer, tileLevel1, tileLevel2) where
import Random
import Map (tilesInView)

starTilesize = 1024
starDensity = 31
l1color = rgb 184 184 184
l2color = rgb 96 96 96

randomList : Int -> Signal [Int]
randomList _ = combine (map (Random.range ((0-starTilesize) `div` 2) (starTilesize `div` 2) . constant) [0..starDensity])

-- A single random star tile
randomTile : Int -> Signal [(Int,Int)]
randomTile num = lift2 zip (randomList (num + 1)) (randomList (num + 2))

type StarTile = (Form, Float)
makeStarTile : Color -> Float -> [(Int,Int)] -> StarTile
makeStarTile color moveRatio points =
  let shape = rect 2 1
      filledRect color = filled color shape
      moved color (x,y) = move (x,y) (filledRect color)
      star color (x,y) = moved color (x,y)
      stars = map (\(x,y) -> star color (x,y)) points
      forms = stars ++ [outlined (solid color) (rect 1024 1024)]
  in (group forms, moveRatio)

-- [stars level 1 (closer), level 2 (farther)]
tileLevel1 : Signal StarTile
tileLevel1 = lift (makeStarTile l1color 2.0) (randomTile 1)

tileLevel2 : Signal StarTile
tileLevel2 = lift (makeStarTile l2color 3.0) (randomTile 2)

--starLayer : ViewPort -> Tile -> ([Form], [(Int,Int)], [Int], [Int])
starLayer vp tile =
  let (vw,vh,sx,sy) = vp
      (f, ratio) = tile
      coords = tilesInView vp (starTilesize) (starTilesize) ratio
      (x, y) = (0-sx/ratio, sy/ratio)
      xy c r = (
        toFloat <| round (toFloat (c * starTilesize) + x),
        toFloat <| round (toFloat ((0-r) * starTilesize) + y)
      )
  in group <| map (\(c,r) -> move (xy c r) f) coords

---- Draw star tiles to the viewport. + debug info
---- My kingdom for an array comprehension.
--starLayers : ViewPort -> [[(Int,Int)]] -> ([Int],[Int],[Form])
--starLayers vp starTiles =
--  -- We pad by half a viewport width/height on each side
--  let (ltr, ttb) = tiles vp starTilesize starTilesize
--      st = starTile vp starTiles
--  in (ltr,ttb,
--    foldl (\r a ->
--       foldl (\c a2 ->
--         a2 ++ st (c,r)
--       ) a ltr
--     ) [] ttb)

---- Draw a particular tile, which is actually two star tiles:
---- Level 1 stars are closer and a bit brighter, and move at /2 speed.
---- Level 2 stars are further, a bit darker, and move even slower.
--starTile : ViewPort -> [[(Int,Int)]] -> (Int, Int) -> [Form]
--starTile (vw,vh,sx,sy) starTiles (c,r)  =
--  let starsLevel1 = head starTiles
--      starsLevel2 = last starTiles
--      absX x = c * starTilesize + x
--      absY y = r * starTilesize + y
--      dx1 x = ((absX x) - sx) / 2
--      dy1 y = ((absY y) - sy) / 2
--      dx2 x = ((absX x) - sx) / 3
--      dy2 y = ((absY y) - sy) / 3
--      shape = rect 1 1
--      filledRect color = filled color shape
--      moved color (x,y) = move (x,y) (filledRect color)
--      star color (x,y) = moved color (x,y)
--  in map (\(x,y) -> star l1color (dx1 x, (0-dy1 y))) starsLevel1 ++
--     map (\(x,y) -> star l2color (dx2 x, (0-dy2 y))) starsLevel2

--main = lift asText <| lift (starLayers (viewPort (0,0,0,0))) starTiles