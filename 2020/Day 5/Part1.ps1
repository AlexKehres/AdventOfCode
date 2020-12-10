using namespace System.Collections.Generic

$Tickets = Get-Content .\input.txt 

$SeatIDs = [List[int]]::new()

$Tickets | foreach {

    # Initialize AvailableRows array (128 rows - 0 indexed) and grab RowCode (first 8 chars of ticket code - 0 indexed)
    
    [int32[]]$AvailableRows = @(0..127)
    [string]$RowCode = $_.Substring(0,7) 

    # Foreach row code value (B/F), cut the AvailableRows in half and select either the first or second half. 
    # Doing this 8 times will narrow the AvailableRows down to a single row.

    for ($i=0;$i -lt $RowCode.Length;$i++) {
        [int]$NumRows = $AvailableRows.Count / 2
        if ($RowCode[$i] -eq "F") {
            $AvailableRows = @($AvailableRows[0]..$AvailableRows[$NumRows - 1])
        } elseif ($RowCode[$i] -eq "B") {
            $AvailableRows = @($AvailableRows[$NumRows]..$AvailableRows[$AvailableRows.Count - 1])
        }
    }

    # Confirm that we only have 1 row left and if so, we have found the tickets row.

    if ($AvailableRows.Count -eq 1) {
        $TickeRow = $AvailableRows[0]
    } else {
        throw "Unable to identify ticket row. $RowCode Narrowed down to $AvailableRows"
    }

    # Initialize AvailableSeats array (8 seats - 0 indexed) and grab SeatCode (last 3 chars of ticket code - 0 indexed)

    [int32[]]$AvailableSeats = @(0..7)
    [string]$SeatCode = $_.Substring(7,3)

    # Foreach seat code value (L/R), cut the AvailableSeats in half and select either the first or second half. 
    # Doing this 3 times will narrow the AvailableSeats down to a single seat.

    for ($i=0;$i -lt $SeatCode.Length;$i++) {
        [int]$NumSeats = $AvailableSeats.Count / 2
        if ($SeatCode[$i] -eq "L") {
            $AvailableSeats = @($AvailableSeats[0]..$AvailableSeats[$NumSeats - 1])
        } elseif ($SeatCode[$i] -eq "R") {
            $AvailableSeats = @($AvailableSeats[$NumSeats]..$AvailableSeats[$AvailableSeats.Count - 1])
        }
    }

    # Confirm that we only have 1 seat left and if so, we have found the tickets seat.

    if ($AvailableSeats.Count -eq 1) {
        $TickeSeat = $AvailableSeats[0]
    } else {
        throw "Unable to identify ticket seat. Narrowed down to $AvailableSeats"
    }

    # Generate Seat ID and add to list of SeatIDs.

    $SeatID = $TickeRow * 8 + $TickeSeat

    $SeatIDs.Add($SeatID)
}

# Report the maximum SeatID found.

$MaxSeatID = ($SeatIDs | Sort)[-1]

return $MaxSeatID