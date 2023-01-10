import { Box } from "@chakra-ui/react";

interface Props {
  color?: string;
  children?: JSX.Element | JSX.Element[];
}

export default function HalfWidthCenter(props: Props) {
  return (
    <Box
      bg={props.color ? props.color : "#EEEEEE"}
      w="50%"
      p={4}
      alignItems="center"
    >
      {props.children}
    </Box>
  );
}
