Program ParameterListEntryContainer_Test

USE iso_fortran_env, only: OUTPUT_UNIT
USE IR_Precision, only: I1P, I2P, I4P, I8P, R4P, R8P, str
USE FPL

type(ParameterList_t) :: Parameters
integer(I1P),     allocatable :: I1PArray
integer(I2P),     allocatable :: I2PArray
integer(I4P),     allocatable :: I4PArray
integer(I8P),     allocatable :: I8PArray
real(R4P),        allocatable :: R4PArray
real(R8P),        allocatable :: R8PArray
logical,          allocatable :: LArray
character(len=:), allocatable :: DLCAarray
integer(I4P),     allocatable :: Shape(:)


if(allocated(I1Parray))  deallocate(I1Parray);  allocate(I1Parray);  I1Parray  = 1
if(allocated(I2Parray))  deallocate(I2Parray);  allocate(I2Parray);  I2Parray  = 2
if(allocated(I4Parray))  deallocate(I4Parray);  allocate(I4Parray);  I4Parray  = 4
if(allocated(I8Parray))  deallocate(I8Parray);  allocate(I8Parray);  I8Parray  = 8
if(allocated(R4Parray))  deallocate(R4Parray);  allocate(R4Parray);  R4Parray  = 0.4
if(allocated(R8Parray))  deallocate(R8Parray);  allocate(R8Parray);  R8Parray  = 0.8
if(allocated(Larray))    deallocate(Larray);    allocate(Larray);    Larray    = .true.
if(allocated(DLCAarray)) deallocate(DLCAarray); allocate(character(len=6):: DLCAarray); DLCAarray = 'String'

call FPL_Init()

call Parameters%Init(Size=3)


write(unit=OUTPUT_UNIT, fmt='(A)') 'Setting Values ...'

if(Parameters%Set(Key='I1P',  Value=I1PArray) /= 0) stop -1
if(Parameters%Set(Key='I2P',  Value=I2PArray) /= 0) stop -1
if(Parameters%Set(Key='I4P',  Value=I4PArray) /= 0) stop -1
if(Parameters%Set(Key='I8P',  Value=I8PArray) /= 0) stop -1
if(Parameters%Set(Key='R4P',  Value=R4PArray) /= 0) stop -1
if(Parameters%Set(Key='R8P',  Value=R8PArray) /= 0) stop -1
if(Parameters%Set(Key='L',    Value=LArray) /= 0) stop -1
if(Parameters%Set(Key='DLCA', Value=DLCAArray) /= 0) stop -1

if(.not. Parameters%isPresent(Key='I1P'))  Stop -1
if(.not. Parameters%isPresent(Key='I2P'))  Stop -1
if(.not. Parameters%isPresent(Key='I4P'))  Stop -1
if(.not. Parameters%isPresent(Key='I8P'))  Stop -1
if(.not. Parameters%isPresent(Key='R4P'))  Stop -1
if(.not. Parameters%isPresent(Key='R8P'))  Stop -1
if(.not. Parameters%isPresent(Key='L'))    Stop -1
if(.not. Parameters%isPresent(Key='DLCA')) Stop -1

write(unit=OUTPUT_UNIT, fmt='(A)') ''
call Parameters%Print(unit=OUTPUT_UNIT)
write(unit=OUTPUT_UNIT, fmt='(A,I4)') ' Parameter List Length: ',Parameters%Length()

write(unit=OUTPUT_UNIT, fmt='(A)') ''
write(unit=OUTPUT_UNIT, fmt='(A)') 'Checking Data Types ...'

write(unit=OUTPUT_UNIT, fmt=*) 'I1P isOfDataType:',  Parameters%isOfDataType(Key='I1P',   Mold=I1PArray)
write(unit=OUTPUT_UNIT, fmt=*) 'I2P isOfDataType:',  Parameters%isOfDataType(Key='I2P',   Mold=I2PArray)
write(unit=OUTPUT_UNIT, fmt=*) 'I4P isOfDataType:',  Parameters%isOfDataType(Key='I4P',   Mold=I4PArray)
write(unit=OUTPUT_UNIT, fmt=*) 'I8P isOfDataType:',  Parameters%isOfDataType(Key='I8P',   Mold=I8PArray)
write(unit=OUTPUT_UNIT, fmt=*) 'R4P isOfDataType:',  Parameters%isOfDataType(Key='R4P',   Mold=R4PArray)
write(unit=OUTPUT_UNIT, fmt=*) 'R8P isOfDataType:',  Parameters%isOfDataType(Key='R8P',   Mold=R8PArray)
write(unit=OUTPUT_UNIT, fmt=*) 'L isOfDataType:',    Parameters%isOfDataType(Key='L',     Mold=LArray)
write(unit=OUTPUT_UNIT, fmt=*) 'DLCA isOfDataType:', Parameters%isOfDataType(Key='DLCA',  Mold=DLCAArray)

write(unit=OUTPUT_UNIT, fmt='(A)') ''
write(unit=OUTPUT_UNIT, fmt='(A)') 'Checking shapes ...'

if(Parameters%GetShape(Key='I1P',  shape=shape) /= 0) stop -1
write(unit=OUTPUT_UNIT, fmt='(A,I4)') 'I1P Shape:',  shape
if(Parameters%GetShape(Key='I2P',  shape=shape) /= 0) stop -1
write(unit=OUTPUT_UNIT, fmt='(A,I4)') 'I2P Shape:',  shape
if(Parameters%GetShape(Key='I4P',  shape=shape) /= 0) stop -1
write(unit=OUTPUT_UNIT, fmt='(A,I4)') 'I4P Shape:',  shape
if(Parameters%GetShape(Key='I8P',  shape=shape) /= 0) stop -1
write(unit=OUTPUT_UNIT, fmt='(A,I4)') 'I8P Shape:',  shape
if(Parameters%GetShape(Key='R4P',  shape=shape) /= 0) stop -1
write(unit=OUTPUT_UNIT, fmt='(A,I4)') 'R4P Shape:',  shape
if(Parameters%GetShape(Key='R8P',  shape=shape) /= 0) stop -1
write(unit=OUTPUT_UNIT, fmt='(A,I4)') 'r8P Shape:',  shape
if(Parameters%GetShape(Key='L',    shape=shape) /= 0) stop -1
write(unit=OUTPUT_UNIT, fmt='(A,I4)') 'L Shape:',  shape
if(Parameters%GetShape(Key='DLCA', shape=shape) /= 0) stop -1
write(unit=OUTPUT_UNIT, fmt='(A,I4)') 'DLCA Shape:',  shape

write(unit=OUTPUT_UNIT, fmt='(A)') ''
write(unit=OUTPUT_UNIT, fmt='(A)') 'Getting Values ...'

if(Parameters%Get(Key='I1P',  Value=I1PArray) /= 0) stop -1
if(Parameters%Get(Key='I2P',  Value=I2PArray) /= 0) stop -1
if(Parameters%Get(Key='I4P',  Value=I4PArray) /= 0) stop -1
if(Parameters%Get(Key='I8P',  Value=I8PArray) /= 0) stop -1
if(Parameters%Get(Key='R4P',  Value=R4PArray) /= 0) stop -1
if(Parameters%Get(Key='R8P',  Value=R8PArray) /= 0) stop -1
if(Parameters%Get(Key='L',    Value=LArray) /= 0) stop -1
if(Parameters%Get(Key='DLCA', Value=DLCAArray) /= 0) stop -1

write(unit=OUTPUT_UNIT, fmt='(A)') ''
write(unit=OUTPUT_UNIT, fmt='(A)') 'Deleting entries ...'

call Parameters%Del(Key='I1P')
call Parameters%Del(Key='I2P')
call Parameters%Del(Key='I4P')
call Parameters%Del(Key='I8P')
call Parameters%Del(Key='R4P')
call Parameters%Del(Key='R8P')
call Parameters%Del(Key='L')
call Parameters%Del(Key='DLCA')

write(unit=OUTPUT_UNIT, fmt='(A)') ''

call Parameters%Free()

call FPL_Finalize()

if(allocated(I1Parray))  deallocate(I1Parray)
if(allocated(I2Parray))  deallocate(I2Parray)
if(allocated(I4Parray))  deallocate(I4Parray)
if(allocated(I8Parray))  deallocate(I8Parray)
if(allocated(R4Parray))  deallocate(R4Parray)
if(allocated(R8Parray))  deallocate(R8Parray)
if(allocated(Larray))    deallocate(Larray)
if(allocated(DLCAarray)) deallocate(DLCAarray)


end Program
