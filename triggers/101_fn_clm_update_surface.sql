CREATE OR REPLACE FUNCTION clm.fn_clm_update_surface()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  SELECT st_area(NEW.geom)
    INTO NEW.surface
    ;
   RETURN NEW;
END
$function$

