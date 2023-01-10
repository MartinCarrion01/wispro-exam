import { Box, FormControl, FormLabel, Input } from "@chakra-ui/react";

interface Props {
  label: string;
  name: string;
  value: string;
  setValue: (e: any) => void;
  password?: boolean;
}

export default function InputText(props: Props) {
  return (
    <>
      <Box
        bg="white"
        w="100%"
        alignItems="center"
        mb="5"
        p={4}
        borderColor="black"
        borderRadius={15}
      >
        <FormControl>
          <FormLabel>{props.label}</FormLabel>
          <Input
            name={props.name}
            value={props.value}
            onChange={(e) => props.setValue(e.target.value)}
            type={props.password ? "password" : "text"}
          />
        </FormControl>
      </Box>
    </>
  );
}
