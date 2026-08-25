# FIRST PHYSICAL MEASUREMENT — Raise Floor Closure

Goal: produce one measured joule number that is not simulated.

## Minimum viable instrument
- 1 thermometer (any digital kitchen or IR)
- 1 mass of thermal storage (water jug, brick, aerocement sample, or dirt-filled can)
- 1 start time + 1 end time

## Protocol (do exactly this)
1. Record ambient air temperature (°C)
2. Record starting temperature of the mass (°C)
3. Place mass in sun or against a warm surface for a fixed interval (minimum 15 min)
4. Record ending temperature of the mass (°C)
5. Record exact duration in seconds
6. Compute:
   ΔT = T_end - T_start
   Approximate energy = mass_kg * 4186 * ΔT   (if water) 
   or mass_kg * specific_heat * ΔT
7. Write the single number (joules) into:
   $HOME/openroot/04_DATA/first_measured_joules.jsonl

That single number is the first real entry that closes the software loop.
